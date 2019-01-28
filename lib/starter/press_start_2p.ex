defmodule Starter.PressStart2P do
  # @on_load :load

  def load() do
    Application.ensure_all_started(:scenic)
    Scenic.Cache.File.load(path(), hash())
    Scenic.Cache.File.read(path(), hash())
    :ok
  end

  def path() do
    Application.app_dir(:starter, ["priv", "PressStart2P.ttf"])
  end

  def hash() do
    {:ok, hash} = Scenic.Cache.Hash.file(path(), :sha)
    hash
  end
end
