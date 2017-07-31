# NervesInitNetKernel

Monitors a network interface for IP addresses changes and restarts the `:net_kernel`.

## Installation
This project works best with
[bootloader](https://github.com/nerves-project/bootloader), so add both it and
`bootloader` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bootloader, "~> 0.1"},
    {:nerves_init_net_kernel, github: "mobileoverlord/nerves_init_net_kernel"}
  ]
end
```

Bootloader requires a plugin to the
[distillery](https://github.com/bitwalker/distillery) configuration, so add
it to your `rel/config.exs` (replace `:your_app`):

```elixir
release :your_app do
  plugin Bootloader.Plugin
  ...
end
```

Now add the following configuration to your `config/config.exs` (replace
`your_app` with your application name):

```elixir
# Boot the bootloader first and have it start our app.
config :bootloader,
  init: [:nerves_network, :nerves_init_net_kernel],
  app: :your_app

config :nerves_init_net_kernel,
  iface: "eth0",
  name: "my_app"
```
