module ProMotionSlideMenu
  class SlideMenuScreen < ECSlidingViewController

    include ::ProMotion::ScreenModule

    #
    # SlideMenuScreen
    #
    # This is added as the root view controller when using the `open_slide_menu` method in your application delegate.
    #
    # Several properties are defined to get the underlying PKRevealController instance for additional configuration, the
    # screen shown as the hidden menu, and the screen shown as the content controller.
    #

    def self.new(content, options={})
      screen = self.slidingWithTopViewController(nil)
      screen.content_controller = content unless content.nil?
      screen.left_controller = options[:left] if options[:left]
      screen.right_controller = options[:right] if options[:right]
      screen_options = options.reject { |k,v| [:left, :right].include? k }
      screen.on_create(screen_options) if screen.respond_to?(:on_create)
      screen
    end

    def show(side, animated=true)
      self.show_left(animated) if side == :left
      self.show_right(animated) if side == :right
    end

    def show_left(animated=true)
      self.anchorTopViewToLeftAnimated animated, onComplete: default_completion_block
    end

    def show_right(animated=true)
      self.anchorTopViewToRightAnimated animated, onComplete: default_completion_block
    end

    def hide(animated=true)
      self.resetTopViewAnimated animated, onComplete: default_completion_block
    end

    def left_controller=(c)
      controller = prepare_controller_for_pm(c)
      controller = controller.navigationController || controller
      self.underLeftViewController = controller
    end

    def left_controller
      self.underLeftViewController
    end

    def right_controller=(c)
      controller = prepare_controller_for_pm(c)
      controller = controller.navigationController || controller
      self.underRightViewController = controller
    end

    def right_controller
      self.underRightViewController
    end

    def content_controller=(c)
      controller = prepare_controller_for_pm(c)
      controller = controller.navigationController || controller
      self.topViewController = controller
    end

    def content_controller
      self.topViewController
    end

    def controller=(side={})
      self.left_controller = side[:left] if side[:left]
      self.right_controller = side[:right] if side[:right]
      self.content_controller = side[:content] if side[:content]
    end

    alias_method :controllers=, :controller=

    def controller(side)
      self.left_controller if side == :left
      self.right_controller if side == :right
      self.content_controller if side == :content
    end

    protected

    def prepare_controller_for_pm(controller)
      controller = set_up_screen_for_open(controller, {})
      ensure_wrapper_controller_in_place(controller, {})
      controller
    end

    def default_completion_block
      -> () { true }
    end

  end
end
