defmodule NervesInitNetKernel.Manager do
  use GenServer

  require Logger

  @scope [:state, :network_interface]

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    iface = opts[:iface]
    name = opts[:name]
    :os.cmd 'epmd -daemon'
    SystemRegistry.register
    {:ok, %{
      name: name,
      iface: iface,
      ip: nil
    }}
  end

  def handle_info({:system_registry, :global, registry}, s) do
    scope = scope(s.iface, [:ipv4_address])
    ip = get_in(registry, scope)
    if ip != s.ip do
      Logger.debug "IP Address Changed"
      Logger.debug "IP: #{inspect ip} Current: #{inspect s.ip}"
      :net_kernel.stop()
      :net_kernel.start([:"#{s.name}@#{ip}"])
    end

    {:noreply, %{s | ip: ip}}
  end

  defp scope(iface, append) do
    @scope ++ [iface] ++ append
  end
end
