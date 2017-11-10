defmodule FredIt.AuthController do
  use FredIt.Web, :controller

  require IEx;
  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  @doc """
  Reached by`/auth/:provider/callback`
  Will request an access token
  Then we can acess to the user in github
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    client = retrieve_token!(provider, code)

    # Request the user's data with the access token
    user = retrieve_user!(provider, client)

    #User will not be maintened into the database
    #Instead will be stored into current_user
    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, client.token.access_token)
    |> redirect(to: "/")
  end

  defp authorize_url!("github"),   do: GitHub.authorize_url!
  defp authorize_url!(_), do: raise "Provider matching failed"

  defp retrieve_token!("github", code),   do: GitHub.get_token!(code: code)
  defp retrieve_token!(_, _), do: raise "Provider matching failed"

  defp retrieve_user!("github", client) do
    %{body: user} = OAuth2.Client.get!(client, "/user")
    %{name: user["name"], avatar: user["avatar_url"], login: user["login"]}
  end

end
