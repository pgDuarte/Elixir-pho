defmodule FredIt.PostController do
  use FredIt.Web, :controller

  alias FredIt.Post
  alias FredIt.Comment

    require Logger

  plug :scrub_params, "comment" when action in [:add_comment]

  def index(conn, _params) do
    posts = Post
    |> Post.count_comments
    |> Repo.all
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do

  #  assign(conn, :valuex, get_session(conn, :current_user))

    conn = fetch_session(conn)
    foo = get_session(conn, :current_user)
    Logger.debug "Var value: #{inspect(foo.login)}"

    map1 = post_params

    new_map = Dict.put_new(post_params, "userId", foo.login)
    Logger.debug "Var value: #{inspect(post_params)}"
    Logger.debug "Var value: #{inspect(new_map)}"
    changeset = Post.changeset(%Post{}, new_map)


    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
       render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    IO.puts "show"
    post = Repo.get(Post, id) |> Repo.preload([:comments])
    changeset = Comment.changeset(%Comment{}, %{id: id})
    render(conn, "show.html", post: post, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    IO.puts "edit"
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    IO.puts "update"
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  def add_comment(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    changeset = Comment.changeset(%Comment{}, Map.put(comment_params, "post_id", post_id))
    post = Post |> Repo.get(post_id) |> Repo.preload([:comments])

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Comment added.")
      |> redirect(to: post_path(conn, :show, post))
    else
      conn
      |> put_flash(:error, "Fred lenght is greater than 140")
      |> render("show.html", post: post, changeset: changeset)
    end
  end

end
