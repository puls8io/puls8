defmodule Puls8.Repo.Migrations.ScopedSequencesTableScopedNextvalPlpgsqlFunction do
  use Ecto.Migration

  def up do
    query_create_table = """
    CREATE TABLE scoped_sequences (
      scope_id uuid NOT NULL,
      entity VARCHAR(255) NOT NULL,
      seq BIGINT NOT NULL,
      CONSTRAINT unique_scope_id_entity_name UNIQUE (scope_id, entity)
    );
    """

    query_create_function = """
    CREATE FUNCTION scoped_nextval(input_entity VARCHAR, input_scope_id uuid)
    RETURNS BIGINT AS $$
    DECLARE
    new_seq BIGINT;
    BEGIN

    INSERT INTO
      scoped_sequences VALUES (input_scope_id, input_entity, 1)
      ON CONFLICT ON CONSTRAINT  unique_scope_id_entity_name
      DO UPDATE SET seq = scoped_sequences.seq + 1
      RETURNING seq INTO new_seq;

    RETURN new_seq;
    END;
    $$ LANGUAGE plpgsql;
    """

    execute query_create_table
    execute query_create_function

    execute """
    CREATE FUNCTION fill_scoped_id()
    RETURNS TRIGGER AS $$
    BEGIN
    NEW.scoped_id := scoped_nextval(TG_ARGV[0], NEW.team_id);
    RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    """
  end

  def down do
    execute "DROP TABLE scoped_sequences"
    execute "DROP FUNCTION scoped_nextval"
    execute "DROP FUNCTION fill_scoped_id"
  end
end
