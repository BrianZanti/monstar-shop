class AdminDashboardFacade
  def initialize
    @orders = Order.by_status
    @grouped_orders = @orders.group_by(&:status)
  end

  def no_orders?
    @orders.empty?
  end

  def pending_orders
    @grouped_orders["pending"] || []
  end

  def packaged_orders
    @grouped_orders["packaged"] || []
  end

  def shipped_orders
    @grouped_orders["shipped"] || []
  end

  def cancelled_orders
    @grouped_orders["cancelled"] || []
  end
end
