class PdfsController < ApplicationController
    require 'zip'
  
    # Action to display existing PDF files
    def all_files
      @pdfs = Pdf.all
      @rvps = Rvp.all
    
      if params[:year].present?
        @selected_year = params[:year].to_i
        @pdfs = @pdfs.select { |pdf| pdf.formatted_date.year == @selected_year }
      else
        @selected_year = Date.current.year
      end
    
      @years = @pdfs.map { |pdf| pdf.formatted_date.year }.uniq.sort
    end
   # Action to create new PDFs
    def save
      rvp = Rvp.find(params[:rvp_id])

      # Ensure that full_name is present in params before calling truncate
      if params[:full_name].present?
        max_name_length = 100
        full_name = params[:full_name].truncate(max_name_length)

        # Generate the desired file name
        today_date = Date.today.strftime("%Y-%m-%d")
        pdf_file_name = "#{full_name} AMC Form #{today_date}.pdf"

        # Debugging: Log the file name length
        Rails.logger.info "PDF File Name Length: #{pdf_file_name.length}"

        pdf = rvp.pdfs.build
        pdf.file.attach(io: params[:pdf].tempfile, filename: pdf_file_name, content_type: 'application/pdf')
        pdf.full_name = full_name

        if pdf.save
          # Create a DownloadedPdf record to associate the PDF with the logged-in user
          # current_user.downloaded_pdfs.create(pdf: pdf)
          render json: { message: 'PDF saved successfully' }, status: :created
        else
          render json: pdf.errors, status: :unprocessable_entity
        end
      else
        # Handle the case where full_name is missing
        flash[:error] = "Full Name is missing in the request."
        redirect_to some_other_path_url  # Redirect to a relevant path or handle it as needed
      end
    end
  
    def pdf_params
      params.permit(:pdf)
    end
  
    def download_selected_pdfs
      selected_pdf_ids = params[:selected_files]
  
      if selected_pdf_ids.present?
        selected_pdfs = Pdf.where(id: selected_pdf_ids).distinct
  
        zip_file_name = "AMC_Forms.zip"
        temp_dir = Rails.root.join("tmp", "selected_pdfs")
  
        # Clear the temp directory before use
        FileUtils.remove_dir(temp_dir) if Dir.exist?(temp_dir)
        FileUtils.mkdir_p(temp_dir)
  
        max_path_length = 255
        added_files = Set.new
  
        Zip::File.open(File.join(temp_dir, zip_file_name), Zip::File::CREATE) do |zipfile|
          selected_pdfs.each do |pdf|
            original_file_path = pdf.file.attachment.blob.service.send(:path_for, pdf.file.blob.key)
  
            unique_file_name = "#{pdf.id}_#{pdf.file.filename.to_s}"
            temp_file_path = File.join(temp_dir, unique_file_name)
  
            if added_files.include?(unique_file_name) || temp_file_path.length > max_path_length
              Rails.logger.error "File already added or path too long: #{unique_file_name}"
              next
            end
  
            added_files.add(unique_file_name)
            FileUtils.cp(original_file_path, temp_file_path)
  
            zipfile.add(unique_file_name, temp_file_path)
  
            # Mark the PDF as downloaded by the current user
            current_user.downloaded_pdfs.create(pdf: pdf)
          end
        end
  
        # Store the file path in the session and redirect to download
        session[:download_zip_path] = File.join(temp_dir, zip_file_name)
        redirect_to download_zip_path
      else
        flash[:error] = "No files selected for download."
        redirect_to all_files_path
      end
    end
  
    # New action to handle downloading the ZIP file
    def download_zip
      zip_path = session[:download_zip_path]
  
      if zip_path && File.exist?(zip_path)
        send_file zip_path, type: 'application/zip', disposition: 'attachment', filename: File.basename(zip_path)
      else
        redirect_to file_not_found_path
      end
    end
  
    # New action to handle file not found errors
    def file_not_found
      flash[:error] = "File not found."
      redirect_to all_files_path
    end

  # New action to handle individual PDF downloads
  def download
    pdf = Pdf.find(params[:id])
  
    # Check if the PDF exists
    if pdf
      # Create a DownloadedPdf record to mark it as downloaded
      current_user.downloaded_pdfs.create(pdf: pdf)
  
      # Send the PDF file for download
      send_data pdf.file.download, filename: pdf.file.filename.to_s, type: 'application/pdf'
    else
      redirect_to file_not_found_path
    end
  end
  end