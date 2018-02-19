defmodule Teacher.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Teacher.Accounts.User
  alias Comeonin.Bcrypt


  schema "users" do
    field :encrypted_password, :string
    field :email, :string
    field :full_name, :string
    field :first_name, :string, virtual: true
    field :last_name, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password, :first_name, :last_name])
    |> build_full_name()
    |> validate_required([:email, :encrypted_password, :full_name])
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end

  defp build_full_name(changeset) do
    first_name = get_field(changeset, :first_name)
    last_name = get_field(changeset, :last_name)
    put_change(changeset, :full_name, "#{first_name} #{last_name}")
  end
end
