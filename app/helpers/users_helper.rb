module UsersHelper
  def gravatar_for user, options = {size: Settings.user.size}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def current_admin user
    return unless current_user.admin? && !current_user?(user)
    link_to t("users.destroy.delete"), user, method: :delete,
      data: {confirm: t("users.destroy.confirm")},
      class: "btn btn-danger"
  end
end
