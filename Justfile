#######################################
# Variables
#######################################

image_name := "stedgeai:3.0.0"

# ST EdgeAI version to use.
stedgeai_version := "0300"

# List of components to install. By default set to all available components
stedgeai_components := "base core stm32mcu stm32mculib stneuralart stm32mpu stellarmcu stellarmculib ispu mlc"

# List of components with stedgeaiXXX. prefix added
# -> For instance, if the chosen version is 0300, will get stedgeai0300.base, etc.
stedgeai_components_full := prepend("stedgeai" + stedgeai_version + ".", stedgeai_components)

# Name of resulting offline installer file
stedgeai_offline_installer := "stedgeai-linux-offline"


# Some properties about the current invocation
uid := `id -u`
gid := `id -g`
cwd := invocation_directory()

# Path to etc directory
etc_dir := join(justfile_dir(), "etc")

# Path to docker directory
docker_dir := join(justfile_dir(), "docker")


#######################################
# Recipes
#######################################

# Check that the given environment variable is defined
env-check-var var:
   @{{ if env_var_or_default(var, "") == "" {"echo 'Please define the " + var + " environment variable' && exit 1"} else {""} }}

components:
	echo {{stedgeai_components_full}}

# Create the offline installer image
create-offline-installer:
	./etc/stedgeai-linux-onlineinstaller --root {{docker_dir}} --offline-installer-name {{stedgeai_offline_installer}} create-offline -c --al --am {{stedgeai_components_full}}

# Build the docker image
image-build:
	docker buildx build --progress=plain -t {{image_name}} --load docker

# Check that the docker image exists
image-check:
	docker images --format='1' -f reference="{{image_name}}"

# Ensure the image has been build before proceeding
image-ensure:
	{{ if `just image-check` != '1' {"just image-build"} else {""} }}


# Execute command in environment
exec *args: image-ensure
	docker run -e HOST_GID={{gid}} -e HOST_UID={{uid}} -w /project --rm -it -v "{{cwd}}":/project {{image_name}} {{args}}

# Starts a web server to display the documentation
documentation:
	docker run -e HOST_GID={{gid}} -e HOST_UID={{uid}} -w /project --rm -p 3000:3000 -v "{{cwd}}":/project {{image_name}} python -m http.server -d /opt/stedgeai/3.0/Documentation -b localhost 3000

# Start a shell in the specified environment
shell:
	just exec bash
