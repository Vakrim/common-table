module TokenAccess

  def authenticate_token!(options = {})
    options.reverse_merge!(
      resource: nil,
      redirect_path: :root_path,
      alert: 'Your token is wrong!',
      token_method: :token
    )

    raise ArguementError.new('Resource is required') if options[:resource].blank?

    check_token = -> {
      record = send(options[:resource])
      if cookies["#{record.class.name}_#{record.id}_token"] != Digest::SHA1.hexdigest("#{record.public_send(options[:token_method])} #{cookies[:user_token]}")
        cookies.delete "#{record.class.name}_#{record.id}_token"
        redirect_to send(options[:redirect_path]), alert: options[:alert]
      end
    }

    before_action check_token, options.slice(:only, :except)

    define_method :set_token! do
      record = send(options[:resource])
      cookies.permanent[:user_token] ||= SecureRandom.base58(24)
      cookies.permanent["#{record.class.name}_#{record.id}_token"] = Digest::SHA1.hexdigest("#{record.public_send(options[:token_method])} #{cookies[:user_token]}")
    end

    include TokenAccess::Helper
  end

  module Helper
    def has_cookie_token?(record)
      cookies["#{record.class.name}_#{record.id}_token"].present?
    end
  end
end
