class ReviewsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    # @review = Review.new(review_params)
    @review = Review.new
    @review.house_id = params[:review][:house_id] 
    @review.factor_id = params[:review][:factor_id] 
    @review.note = params[:review][:note] 
    @review.user_id = current_user.id

    @rate  = Rate.new
    @rate.text_input = params[:review][:text_input]
    @rate.integer_input = params[:review][:integer_input]
    @rate.start_range = params[:review][:start_range]
    @rate.end_range= params[:review][:end_range]
    @rate.float_input= params[:review][:float_input]
    # :factor_id, :note :house_id, :factor_id, :note
    respond_to do |format|
      if @rate.save
        if @review.save
          @rate.review_id= @review.id
          format.html { redirect_to @review, notice: 'Review was successfully created.' }
          format.json { render action: 'show', status: :created, location: @review }
        else
          format.html { render action: 'new' }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:house_id, :factor_id, :note, :text_input, :integer_input, :start_range, :end_range, :float_input , :review_id)
    end
end
