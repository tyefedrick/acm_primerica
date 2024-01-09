class PdfsController < ApplicationController
    # Action to display existing PDF files
    def all_files
      # Assuming you have a model called `Pdf` associated with `Rvp`
      @pdfs = Pdf.all # Adjust this to fetch the PDF records you want to display
    end
  
    # Action to create new PDFs
    def save
        # Assuming you have a model called `Pdf` associated with `Rvp`
        rvp = Rvp.find(params[:rvp_id]) # Adjust as per your parameter naming
    
        # Get the full name from the request parameters
        full_name = params[:full_name] # Make sure this matches the parameter name in your form
    
        # Generate the desired file name
        today_date = Date.today.strftime("%Y-%m-%d")
        pdf_file_name = "#{full_name} AMC Form #{today_date}.pdf"
    
        pdf = rvp.pdfs.build
        pdf.file.attach(io: params[:pdf].tempfile, filename: pdf_file_name, content_type: 'application/pdf')
    
        # Set the full_name attribute of the Pdf model
        pdf.full_name = full_name
    
        if pdf.save
          # Respond with success
          render json: { message: 'PDF saved successfully' }, status: :created
        else
          # Respond with error
          render json: pdf.errors, status: :unprocessable_entity
        end
      end
  
    def pdf_params
      # Permit the :pdf attribute
      params.permit(:pdf)
    end
  end