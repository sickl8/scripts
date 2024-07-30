mv package.json package.old.json
dev=$(echo `jq -r '(.devDependencies // {}) | keys[]' package.old.json`)
ndev=$(echo `jq -r '(.dependencies // {}) | keys[]' package.old.json`)
jq 'del(.dependencies, .devDependencies)' package.old.json > package.json
if [ -n "$dev" ]; then
	npm i -D $dev
fi
if [ -n "$ndev" ]; then
	npm i $ndev
fi