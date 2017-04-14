defmodule SocialPresence.Web.UserChannelTest do
  use SocialPresence.Web.ChannelCase

  alias SocialPresence.Web.UserChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{user_id: 1})
      |> subscribe_and_join(UserChannel, "user:1")

    {:ok, socket: socket}
  end

  test "does not allow joins on other users channels", %{socket: socket} do
    assert {:error, %{reason: "unauthorized"}} == subscribe_and_join(socket, UserChannel, "user:2")
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to user:1", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
