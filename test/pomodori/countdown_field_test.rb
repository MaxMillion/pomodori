require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/countdown_field'
require 'pomodori/countdown'

class CountdownFieldTest < Test::Unit::TestCase
  
  def setup
    @countdown_field = CountdownField.new
  end
  
  def test_should_format_time
    @countdown_field.start(1)
    assert_equal("00:01", @countdown_field.time)
    @countdown_field.start(60)
    assert_equal("01:00", @countdown_field.time)
    @countdown_field.start( (60*25)-1 )
    assert_equal("24:59", @countdown_field.time)
  end
  
  def test_prints_done_when_done
    @countdown_field.start(1)
    @countdown_field.on_timer_tick
    assert_equal("00:00", @countdown_field.render.to_s)
    @countdown_field.on_timer_tick
    assert_equal("Done!", @countdown_field.render.to_s)
  end

  def test_state_is_stopped_after_finished
    @countdown_field.start(1)
    @countdown_field.on_timer_tick
    assert_equal(:done, @countdown_field.state)
  end

  def test_should_play_sound
    sound = mock
    @countdown_field.expects(:sound).returns(sound)
    sound.expects(:play)
    @countdown_field.ring
  end
  
  def test_rings_on_count_done
    @countdown_field.expects(:ring)
    @countdown_field.send(:on_countdown_done)
  end
  
end

class CountdownFieldTimerTest < Test::Unit::TestCase
  attr_accessor :called
  
  def setup
    @countdown_field = CountdownField.new
  end
  
  def test_moves_state_to_running
    @countdown_field.start(25*60)
    assert_equal(:running, @countdown_field.state)
  end
  
  def test_saves_start_time
    @countdown_field.start(25*60)
    assert_not_nil(@countdown_field.start_time)    
  end
  
  def test_should_update_text_on_tick
    @countdown_field.start(25*60)
    @countdown_field.on_timer_tick
    assert_equal("24:59", @countdown_field.render.to_s)
  end
  
  def test_passing_a_specific_callback
    @countdown_field.start(1, method(:callback))
    @countdown_field.on_timer_tick
    assert(@called)
  end
  
  def callback
    @called = true
  end
  
end

