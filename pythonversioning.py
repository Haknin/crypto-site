import docker
client = docker.from_env()
images = client.images.list()
existing_versions = [
    float(image.tags[0].split(":")[1])
    for image in images
    if image.tags and image.tags[0].startswith("haknin/crypto_docker:")
]
if existing_versions:
    latest_version = max(existing_versions)
    next_version = latest_version + 0.1
else:
    next_version = 1.0
# Format the version number to one decimal place
next_version = round(next_version, 1)
image_name = f"haknin/crypto_docker:{next_version}"
client.images.build(path=".", tag=image_name, rm=True, pull=True)
print(f"Successfully built image: {image_name}")
# Push the image with the specified tag
client.images.push(repository="haknin/crypto_docker", tag=next_version)
print(f"Successfully pushed image: {image_name}")
# Push the image with the 'latest' tag
latest_tag = "latest"
latest_image_name = f"haknin/crypto_docker:{latest_tag}"
image_to_tag = client.images.get(image_name)
image_to_tag.tag(repository="haknin/crypto_docker", tag=latest_tag)
client.images.push(repository="haknin/crypto_docker", tag=latest_tag)
print(f"Successfully pushed image: {latest_image_name}")
# Clean up older versions of the image
for image in images:
    if image.tags and image.tags[0].startswith("haknin/crypto_docker:"):
        version = float(image.tags[0].split(":")[1])
        if version != float(latest_version) and version != float(next_version):
            client.images.remove(image.id, force=True)
            print(f"Successfully removed image: {image.tags[0]}")
