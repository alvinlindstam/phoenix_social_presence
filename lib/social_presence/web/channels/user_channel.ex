defmodule SocialPresence.Web.UserChannel do
  use SocialPresence.Web, :channel

  def join("user:" <> user_id_str, payload, socket) do
    if to_string(socket.assigns.user_id) == user_id_str do
        {:ok, socket}
    else
        {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (user:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end
end
