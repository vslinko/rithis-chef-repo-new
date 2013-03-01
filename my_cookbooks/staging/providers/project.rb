action :enable do
    dir = "#{node["staging"]["dir"]}/#{new_resource.name}"

    directory dir do
        recursive true
    end

    git dir do
        reference new_resource.reference
        repository new_resource.repository
        notifies :run, "execute[npm install]", :immediately
    end

    execute "npm install" do
        cwd dir
        action :nothing
    end

    runit_service "staging-#{new_resource.name}" do
        options(
            :dir => dir,
            :port => new_resource.port
        )
        default_logger true
        run_template_name "staging"
    end
end

action :disable do
    runit_service "staging-#{new_resource.name}" do
        action :disable
    end
end
