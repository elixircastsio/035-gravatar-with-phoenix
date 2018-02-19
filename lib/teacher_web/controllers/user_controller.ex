defmodule TeacherWeb.UserController do
  use TeacherWeb, :controller

  alias Teacher.Accounts
  alias Teacher.Accounts.User

  def show(conn, %{"id" => user_id}) do
    user = Accounts.get_user!(user_id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user)
        |> put_flash(:info, "Signed up successfully.")
        |> redirect(to: movie_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
