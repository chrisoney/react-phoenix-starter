defmodule Chatter.Services.Authenticator do
  # These values must be moved in a configuration file
  @seed "user token"
# good way to generate: 
  # :crypto.strong_rand_bytes(30) 
  # |> Base.url_encode64 
  # |> binary_part(0, 30)
  @secret "tu54Q9Jh6IYrq25ByRHUoP9Bs4XrlZvm"
  def generate_token(id) do
    Phoenix.Token.sign(@secret, @seed, id, max_age: 86400)
  end
  def verify_token(token) do
    case Phoenix.Token.verify(@secret, @seed, token, max_age: 86400) do
      {:ok, _id} -> {:ok, token}
      error -> error
    end
  end

  def get_auth_token(conn) do
    case extract_token(conn) do
      {:ok, token} ->
        verify_token(token)
      error -> error
    end
  end
  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] -> get_token_from_header(auth_header)
       _ -> {:error, :missing_auth_header}
    end
  end
  defp get_token_from_header(auth_header) do
    {:ok, reg} = Regex.compile("Bearer\:?\s+(.*)$", "i")
    case Regex.run(reg, auth_header) do
      [_, match] -> {:ok, String.trim(match)}
      _ -> {:error, "token not found"}
    end
  end
end