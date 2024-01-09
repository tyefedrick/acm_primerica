class PdfsController < ApplicationController
    def save
      # Assuming you have a model called `Pdf` associated with `Rvp`
      rvp = Rvp.find(params[:rvp_id]) # Adjust as per your parameter naming
  
        # Get the full name from the request parameters
    full_name = params[:full_name] # Make sure this matches the parameter name in your form

    # Generate the desired file name
    today_date = Date.today.strftime("%Y-%m-%d")
    pdf_file_name = "#{full_name} ACM Form #{today_date}.pdf"

    pdf = rvp.pdfs.build
    pdf.file.attach(io: params[:pdf].tempfile, filename: pdf_file_name, content_type: 'application/pdf')

  
      if pdf.save
        # Respond with success
        render json: { message: 'PDF saved successfully' }, status: :created
      else
        # Respond with error
        render json: pdf.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def pdf_params
      # Permit the :pdf attribute
      params.permit(:pdf)
    end
  end