module HammerCLIKatello
  class ContentViewPuppetModule < HammerCLIKatello::Command
    resource :content_view_puppet_modules
    command_name 'puppet-module'
    desc 'View and manage puppet modules'

    class ListCommand < HammerCLIKatello::ListCommand
      include OrganizationOptions

      output do
        field :uuid, _("UUID")
        field :name, _("Name")
        field :author, _("Author")
        field :version, _("Version")
      end

      def extend_data(mod)
        mod['version'] = if mod['uuid']
                           mod['computed_version']
                         else
                           _("Latest(Currently %s)") % mod['computed_version']
                         end
        mod
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      include OrganizationOptions

      command_name "add"

      success_message _("Puppet module added to content view.")
      failure_message _("Could not add the puppet module")

      build_options

      def get_identifier(*)
        # This will intentionally disable the id resolver.  Without it, if the user were to
        # execute the 'add' command specifying a 'name', the id resolver will attempt to
        # translate the 'name' to an 'id'.  That is not desirable for this command.
        nil
      end
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include OrganizationOptions

      command_name "remove"

      success_message _("Puppet module removed from content view.")
      failure_message _("Couldn't remove puppet module from the content view")

      build_options
    end

    autoload_subcommands
  end
end
