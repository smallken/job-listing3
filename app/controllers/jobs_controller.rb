class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :validate_search_key, only: [:search]


  def index
    @jobs = case params[:order]
              when 'by_lower_bound'
              Job.published.order('wage_lower_bound DESC')
              when 'by_upper_bound'
              Job.published.order('wage_upper_bound DESC')
              else
              Job.published.recent
            end
  end

  def show
      @job = Job.find(params[:id])

      @category = @job.category
      # 随机推荐五个相同类型的职位（去除当前职位） #
      @sames = Job.where(:is_hidden => false, :category => @job.category).where.not(:id => @job.id ).random5

      if @job.is_hidden
        redirect_to root_path, alert: "此职缺暂未开放。"
      end
    end

  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "This Job already achieved"
      redirect_to root_path
    end
  end


  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])

    @job.destroy

    redirect_to jobs_path
  end

  def search
    if @query_string.present?
      search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
      @jobs = search_result.recent.paginate(:page => params[:page], :per_page => 5 )
    end
  end

  protected
  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
    if params[:q].present?
      @search_criteria =  {
        title_or_company_or_city_cont: @query_string
      }
    end
  end

  def search_criteria(query_string)
    { :title_cont => query_string }
  end


  private

  def job_params
    params.require(:job).permit(:title,:description,:wage_upper_bound,:wage_lower_bound,:contact_email,:is_hidden,:category,:company,:city)
  end

end
