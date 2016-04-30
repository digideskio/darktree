module CardHelper
  def status_to_s(status)
    if status
      'learned'
    else
      'not-learned'
    end
  end
end
