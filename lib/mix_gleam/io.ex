defmodule MixGleam.IO do
  @app Mix.Project.config()[:app]
  @shell Mix.shell()

  @moduledoc false

  def debug_info(header, text \\ "", loc \\ @app) do
    if System.get_env("MIX_DEBUG") == "1" do
      shell_info(header, text, loc)
    end

    :ok
  end

  def shell_info(header, text \\ "", loc \\ @app) do
    @shell.info([:inverse, "|#{loc}| #{header}", :reset])
    @shell.info(text)
  end

  def shell_warn(header, text \\ "", loc \\ @app) do
    @shell.error([:inverse, :red, "|#{loc}| #{header}", :reset])
    @shell.error(text)
  end

  def gleam_env_info() do
    @shell.info([
      :green,
      """

      Gleam Environment
        MIX_ENV: #{Mix.env()}
      """,
      :reset
    ])
  end
end
