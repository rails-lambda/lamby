class ApplicationController < ActionController::Base
  helper_method :logged_in?

  def index
    render
  end

  def image
    data = File.read Rails.root.join('app/images/1.png')
    send_data data, type: 'image/png', disposition: 'inline'
  end

  def login
    if params[:password] == 'password'
      session[:logged_in] = 'true'
    end
    redirect_to root_url
  end

  def logout
    reset_session
    redirect_to root_url
  end

  def exception
    raise 'hell'
  end

  def percent
    render
  end

  def cooks
    cookies['1'] = '1'
    cookies['2'] = '2'
    render :index
  end

  private

  def logged_in?
    session[:logged_in] == 'true'
  end
end
