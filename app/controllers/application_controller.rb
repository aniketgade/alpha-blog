class ApplicationController < ActionController::Base
  include ApplicationHelper
  include LocaleHelper
  before_action :update_user_locale
  before_action :set_locale
  before_action :redirect_no_locale

  private

  def redirect_no_locale
    return if params[:locale].present? || Rails.env.test?

    redirect_to url_for(params.to_unsafe_h.merge(locale: I18n.locale, only_path: true))
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
