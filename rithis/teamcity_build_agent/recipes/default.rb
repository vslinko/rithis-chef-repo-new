include_recipe "mongodb"
include_recipe "nodejs"
include_recipe "teamcity_server::build_agent"

package "make"
package "python-pygments"
