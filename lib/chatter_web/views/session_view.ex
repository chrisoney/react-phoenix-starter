defmodule ChatterWeb.SessionView do
  use ChatterWeb, :view
  def render("show.json", %{auth_token: %{token: token} = auth_token, user: user}) do
    %{
      token: token, 
      user:  %{id: user.id,
              username: user.username,
              email: user.email
            }
      }
  end

end