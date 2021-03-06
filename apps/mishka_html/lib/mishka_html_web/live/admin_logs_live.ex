defmodule MishkaHtmlWeb.AdminLogsLive do
  use MishkaHtmlWeb, :live_view

  def mount(_params, _session, socket) do
    Process.send_after(self(), :menu, 100)
    {:ok, assign(socket, page_title: "مدیریت لاگ ها", body_color: "#a29ac3cf")}
  end

  def handle_info(:menu, socket) do
    AdminMenu.notify_subscribers({:menu, "Elixir.MishkaHtmlWeb.AdminLogsLive"})
    {:noreply, socket}
  end
end
