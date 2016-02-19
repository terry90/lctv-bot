class TestPlugin < LCTVPlugin
  def process(m)
    m.body == 'I love docc' ? true : false
  end

  def msg
    'Me too !'
  end
end
