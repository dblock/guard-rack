class HelloWorld
  def call(env)
    return [
      200,
      {'Content-Type' => 'text/html'},
      ["Hello world!"]
    ]
  end
end

run HelloWorld.new
