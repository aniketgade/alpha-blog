# frozen_string_literal: true

module LocaleHelper
  def browser_locale
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first || 'en'
  end

  def set_locale
    requested_locale = if current_user.present?
      current_user.locale
    elsif cookies.permanent[:locale]
      cookies.permanent[:locale]
    else
      extract_browser_locale request.env['HTTP_ACCEPT_LANGUAGE']
    end

    requested_locale = requested_locale.try(:to_sym)

    I18n.locale = if requested_locale && I18n.available_locales.include?(requested_locale)
      requested_locale
    else
      I18n.default_locale
    end
  end

  def extract_browser_locale(http_accept_language)
    http_accept_language.to_s.scan(/[a-z]{2}(?:-[A-Z]{2})?/).detect do |candidate|
      I18n.available_locales.include?(candidate.to_sym)
    end
  end

  def update_user_locale
    return if params[:locale].blank?

    locale = params[:locale].to_sym
    return unless locale.to_s.downcase.to_sym.in?(I18n.available_locales.map(&:downcase))

    if current_user.present?
      current_user.update! locale: locale
    else
      cookies.permanent[:locale] = locale
    end
  end
end
