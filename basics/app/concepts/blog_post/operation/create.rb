require_relative "../contract/create"

class BlogPost::Create < Trailblazer::Operation
  step Policy::Guard(:authorize!)
  step Model(BlogPost, :new)
  step Contract::Build(constant: BlogPost::Contract::Create)
  step Contract::Validate(key: :blog_post)
  step Contract::Persist()
  step :notify!

  def authorize!(options, current_user:, **)
    current_user.signed_in?
  end

  def notify!(options, current_user:, model:, **)
    options["result.notify"] = BlogPost::Notification.(current_user, model)
  end
end
