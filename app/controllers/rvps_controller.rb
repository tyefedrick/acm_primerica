class RvpsController < ApplicationController
  before_action :set_rvp, only: %i[ show edit update destroy ]

  # GET /rvps or /rvps.json
  def index
    @rvps = Rvp.all
    @rvps = @rvps.sort_by { |rvp| rvp.first_name }
    puts @rvps.inspect  # Debugging line to print @rvps to console
  end

  # GET /rvps/1 or /rvps/1.json
  def show
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
    @rvp.destroy

    respond_to do |format|
      format.html { redirect_to rvps_url, notice: "Rvp was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def files
    @rvp = Rvp.find(params[:id])
    @pdfs = @rvp.pdfs
  end

  def all_files
    @pdfs = Pdf.all
    @rvps = Rvp.all
    @favorites = current_user.favorites

    # Initialize @favorite_pdfs as an empty hash
    @favorite_pdfs = Hash.new { |hash, key| hash[key] = [] }

    # Assuming 'favorites' is a method that returns the RVP IDs of the user's favorites
    favorite_rvp_ids = current_user.favorites.pluck(:rvp_id)

    # Preload PDFs for the favorited RVPs
    Pdf.where(rvp_id: favorite_rvp_ids).find_each do |pdf|
      @favorite_pdfs[pdf.rvp_id] << pdf
    end

    # Fetch the favorites and include the associated RVPs
    favorites_with_rvps = current_user.favorites.includes(:rvp)

    # Sort the favorites by the RVP's first name
    @sorted_favorites = favorites_with_rvps.sort_by { |favorite| favorite.rvp.first_name }

    # Query distinct years based on the formatted_date attribute
    @years = @pdfs.reject { |pdf| pdf.formatted_date.nil? }
                   .map { |pdf| pdf.formatted_date.year }
                   .uniq
                   .sort
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rvp
      @rvp = Rvp.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rvp_params
      params.require(:rvp).permit(:first_name, :last_name, :solution_number)
    end
end
