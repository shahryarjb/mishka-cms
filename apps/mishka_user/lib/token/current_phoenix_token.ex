defmodule MishkaUser.Token.CurrentPhoenixToken do
  alias MishkaUser.Token.TokenManagemnt
  @hard_secret_current "Test current"

  def create_token(id, :current) do
    token = Phoenix.Token.sign(MishkaApiWeb.Endpoint, @hard_secret_current, %{id: id, type: "access"}, [key_digest: :sha256])
    {:ok, :current, token}
  end


  def save_token(user_info) do
    MishkaUser.Token.TokenDynamicSupervisor.start_job([id: user_info.id, type: "token"])
    {:ok, type, token} = create_token(user_info.id, :current)
    TokenManagemnt.save(%{
      id: user_info.id,
      token_info:
        [
          %{
            token_id: Ecto.UUID.generate,
            type: Atom.to_string(type),
            token: token,
            os: "linux",
            create_time: System.system_time(:second),
            last_used: System.system_time(:second),
            access_expires_in: token_expire_time(:current).unix_time,
            rel: nil
          }
        ]
    }, user_info.id)

    {:ok, :save_token, token}
  end

  def verify_token(token, :current) do
    Phoenix.Token.verify(MishkaApiWeb.Endpoint, @hard_secret_current, token, [max_age: token_expire_time(:current).age])
    |> verify_token_condition(:current)
    |> verify_token_on_state(token)
  end

  defp verify_token_condition(state, type) do
    state
    |> case do
      {:ok, clime} -> {:ok, :verify_token, type, clime}
      {:error, action} -> {:error, :verify_token, type, action}
    end
  end

  defp verify_token_on_state({:ok, :verify_token, type, clime}, token) do
    case TokenManagemnt.get_token(clime.id, token) do
      nil -> {:error, :verify_token, type, :token_otp_state}
      state ->
        {:ok, :verify_token, type,
        Map.new(state, fn {k, v} -> {Atom.to_string(k), v} end)
        |> Map.merge(%{"id" => clime.id})
      }
    end
  end

  defp verify_token_on_state({:error, :verify_token, type, action}, _token), do: {:error, :verify_token, type, action}

  defp token_expire_time(:current) do
    %{
      unix_time: DateTime.utc_now() |> DateTime.add(10800, :second) |> DateTime.to_unix(),
      age: 10800
    }
  end
end
