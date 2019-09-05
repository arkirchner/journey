module ApplicationHelper
  def github_auth_path
    "#{auth_path}/#{:github}"
  end

  def developer_auth_path
    "#{auth_path}/#{:developer}"
  end
end
