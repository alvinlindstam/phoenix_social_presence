defmodule SocialPresence.Web.UserChannel do
  use SocialPresence.Web, :channel

  alias SocialPresence.Web.MyPresence

  def join("user:" <> user_id_str, payload, socket) do
    if to_string(socket.assigns.user_id) == user_id_str do
        send(self, :after_join)
        {:ok, socket}
    else
        {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket = %{assigns: %{user_id: user_id}}) do
    friend_list = [user_id, user_id + 1]
    presence_state = get_and_subscribe_presence_multi socket, friend_list(user_id)
    push socket, "presence_state", presence_state
    track_user_presence(user_id)
    {:noreply, socket}
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

  # Let's pretend that the current user is allowed to see the presence of users with an id between
  # 10 less than and 100 more than it's own id.
  defp friend_list(user_id) do
    Enum.to_list(user_id - 10..user_id + 100)
  end

  # Track the current process as a presence for the given user on it's designated presence topic
  defp track_user_presence(user_id) do
    {:ok, _} = MyPresence.track(self(), presence_topic(user_id), user_id, %{
      online_at: inspect(System.system_time(:seconds))
    })
  end

  # Find the presence topics of all given users. Get their presence state and subscribe the current
  # process (channel) to their presence updates.
  defp get_and_subscribe_presence_multi(socket, user_ids) do
    user_ids
      |> Enum.map(&presence_topic/1)
      |> Enum.uniq
      |> Enum.map(fn topic ->
           :ok = Phoenix.PubSub.subscribe(
             socket.pubsub_server,
             topic,
             fastlane: {socket.transport_pid, socket.serializer, []}
           )
           MyPresence.list(topic)
         end)
      |> Enum.reduce(%{}, fn map, acc -> Map.merge(acc, map) end)
  end

  defp presence_topic(user_id) do
    "user_presence:#{user_id}"
  end
end
