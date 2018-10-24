class SuggestionsController < ApplicationController
  before_action :admin_user, only: [:index, :edit]
  before_action :load_suggestion, only: [ :edit, :update]
  before_action :load_categories, only: [:new, :create]
  before_action :load_suggestion_statuses, only: [:index, :personal_show]

  def index
    @suggestions = Suggestion.order(created_at: :desc).paginate page: params[:page]
  end

  def personal_show
    @suggestions = Suggestion.personal(current_user.id).paginate page: params[:page]
  end

  def new
    @suggestion = Suggestion.new
  end

  def create
    @suggestion = current_user.suggestions.build suggestion_params
    if @suggestion.save
      flash[:success] = t ".success_create"
      redirect_to mySuggestions_path
    else
      render :new
    end
  end

  def edit; end

  def update
    @suggestion.status = suggestion_status_params[:status]
    if @suggestion.save
      flash[:success] = t ".success_update"
      redirect_to suggestions_path
    else
      render @suggestions
    end
  end

  private

  def load_suggestion
    @suggestion = Suggestion.find_by id: params[:id]
    return if @suggestion.present?
    flash[:danger] = t ".notfound"
    redirect_to root_path
  end

  def suggestion_params
    params.require(:suggestion).permit :name, :description, :image, :category_id
  end

  def load_categories
    @categories = Category.all.map{|m| [m.name, m.id]}
  end

  def load_suggestion_statuses
    load_status Suggestion
  end

  def suggestion_status_params
    params.require(:suggestion).permit :status
  end

  def admin_user
    return unless current_user.present?
    redirect_to root_path unless current_user.admin?
  end
end
