class SerializedError < SimpleDelegator
  # should receive a resource.errors object and return jsonapi serialized
  def unauthorized
  {:errors => [
    :status => "401",
    :title => "Unauthorized",
    :detail => "Authentication required"
  ]} 
  end

  def bad_request
    {:errors => [
      :status => "400",
      :title => "Bad request",
      :detail => full_messages.join(",") 
    ]}
  end

  def not_found
    {:data => nil}  
  end

  def empty_collection
    {:data => []}
  end
end
