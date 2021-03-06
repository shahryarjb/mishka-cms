defmodule MishkaContent.General.Notif do
  alias MishkaDatabase.Schema.MishkaContent.Notif

  import Ecto.Query
  use MishkaDatabase.CRUD,
          module: Notif,
          error_atom: :notif,
          repo: MishkaDatabase.Repo

  @behaviour MishkaDatabase.CRUD

  def create(attrs) do
    crud_add(attrs)
  end

  def create(attrs, allowed_fields) do
    crud_add(attrs, allowed_fields)
  end

  def edit(attrs) do
    crud_edit(attrs)
  end

  def edit(attrs, allowed_fields) do
    crud_edit(attrs, allowed_fields)
  end

  def delete(id) do
    crud_delete(id)
  end

  def show_by_id(id) do
    crud_get_record(id)
  end

  def notifs(conditions: {page, page_size, :client}, filters: filters) do
    from(notif in Notif) |> convert_filters_to_where(filters)
    |> fields(:client)
    |> MishkaDatabase.Repo.paginate(page: page, page_size: page_size)
  rescue
    Ecto.Query.CastError ->
      %Scrivener.Page{entries: [], page_number: 1, page_size: page_size, total_entries: 0,total_pages: 1}
  end

  def notifs(conditions: {page, page_size}, filters: filters) do
    from(notif in Notif) |> convert_filters_to_where(filters)
    |> fields()
    |> MishkaDatabase.Repo.paginate(page: page, page_size: page_size)
  rescue
    Ecto.Query.CastError ->
      %Scrivener.Page{entries: [], page_number: 1, page_size: page_size, total_entries: 0,total_pages: 1}
  end

  defp convert_filters_to_where(query, filters) do
    Enum.reduce(filters, query, fn {key, value}, query ->
      from notif in query, where: field(notif, ^key) == ^value
    end)
  end

  defp fields(query, :client) do
    from [notif] in query,
    left_join: user in assoc(notif, :users),
    or_where: is_nil(notif.user_id),
    order_by: [desc: notif.inserted_at, desc: notif.id],
    select: %{
      id: notif.id,
      status: notif.status,
      section: notif.section,
      section_id: notif.section_id,
      short_description: notif.short_description,
      expire_time: notif.expire_time,
      extra: notif.extra,
      user_id: notif.user_id
    }
  end

  defp fields(query) do
    from [notif] in query,
    left_join: user in assoc(notif, :users),
    order_by: [desc: notif.inserted_at, desc: notif.id],
    select: %{
      id: notif.id,
      status: notif.status,
      section: notif.section,
      section_id: notif.section_id,
      short_description: notif.short_description,
      expire_time: notif.expire_time,
      extra: notif.extra,
      user_id: notif.user_id
    }
  end
  def allowed_fields(:atom), do: Notif.__schema__(:fields)
  def allowed_fields(:string), do: Notif.__schema__(:fields) |> Enum.map(&Atom.to_string/1)
end
