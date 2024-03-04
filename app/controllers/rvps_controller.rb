class RvpsController < ApplicationController
  before_action :set_rvp, only: %i[ show edit update destroy unarchive toggle_proctor ]
  skip_before_action :set_rvp, only: [:proctored]

  # GET /rvps or /rvps.json
  def index
    @rvps = Rvp.all
    @rvps = Rvp.all.sort_by { |rvp| [rvp.favorite_by_user?(current_user) ? "0" : "1", rvp.first_name] }
    puts @rvps.inspect  # Debugging line to print @rvps to console
    #@sorted_rvps = fetch_all_rvps.sort_by { |rvp| rvp.first_name }
  end

  # GET /rvps/1 or /rvps/1.json
  def show
    @pdfs = @rvp.pdfs
  end

  # GET /rvps/new
  def new
    @rvp = Rvp.new
  end

  # GET /rvps/1/edit
  def edit
  end

  # POST /rvps or /rvps.json
  def create
    @rvp = Rvp.new(rvp_params)

    respond_to do |format|
      if @rvp.save
        format.html { redirect_to rvp_url(@rvp), notice: "Rvp was successfully created." }
        format.json { render :show, status: :created, location: @rvp }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rvp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rvps/1 or /rvps/1.json
  def update
    respond_to do |format|
      if @rvp.update(rvp_params)
        format.html { redirect_to rvp_url(@rvp), notice: "Rvp was successfully updated." }
        format.json { render :show, status: :ok, location: @rvp }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rvp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rvps/1 or /rvps/1.json
  def destroy
    @rvp.archive

    respond_to do |format|
      format.html { redirect_to rvps_url, notice: "Rvp was successfully archived." }
      format.json { head :no_content }
    end
  end

  def files
    @rvp = Rvp.find(params[:id])
    @pdfs = @rvp.pdfs
  end

  def all_files
    @rvps = Rvp.all.sort_by { |rvp| [rvp.favorite_by_user?(current_user) ? "0" : "1", rvp.first_name] }
  end

  def archived
    @rvps = Rvp.archived.sort_by { |rvp| [rvp.favorite_by_user?(current_user) ? "0" : "1", rvp.first_name] }
    puts @rvps.inspect  # Debugging line to print @rvps to console
    #@sorted_rvps = fetch_all_rvps.sort_by { |rvp| rvp.first_name } 
    # Assuming there's a scope `archived` in your Rvp model that fetches archived RVPs
    @archived_rvps = Rvp.archived
    # If you don't have a scope, but an `archived` boolean field, you might do:
    # @archived_rvps = Rvp.where(archived: true)
  end

  def unarchive
    @rvp.unarchive

    respond_to do |format|
      format.html { redirect_to rvps_url, notice: "Rvp was successfully unarchived." }
      format.json { head :no_content }
    end 
  end

  def toggle_proctor
    @rvp = Rvp.find(params[:id])
    @rvp.toggle_proctor_status!
    
    respond_to do |format|
      format.html { redirect_to @rvp }
      format.json { head :no_content } # Respond with empty body for AJAX request
    end
  end

  def proctored
    @proctored_rvps = Rvp.where(proctor_status: :proctor).order(:first_name)
    
  end

  def formatted_name
    "#{first_name} #{last_name} - #{solution_number}"
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rvp
      id = params[:id] || params[:rvp_id]
      @rvp = Rvp.unscoped.find(id)
    end

    # Only allow a list of trusted parameters through.
    def rvp_params
      params.require(:rvp).permit(:first_name, :last_name, :solution_number)
    end
end
