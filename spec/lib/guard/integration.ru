class HelloWorld
  def call(_env)
    [
      200,
      { 'Content-Type' => 'text/html' },
      ['Hello world!']
    ]
  end
end

run HelloWorld.new
