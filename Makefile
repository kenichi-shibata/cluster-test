WAIT := 200s
APPLY = kubectl apply --kubeconfig=$$(kind get kubeconfig-path --name $@) --validate=false --filename
NAME = $$(echo $@ | cut -d "-" -f 2- | sed "s/%*$$//")

tekton tekton%: create-tekton%
	@$(APPLY) https://storage.googleapis.com/tekton-releases/latest/release.yaml

gatekeeper gatekeeper%: create-gatekeeper%
	@$(APPLY) https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper-constraint.yaml

create-%:
	kind create cluster --name $(NAME) --wait $(WAIT)

create3-%:
	kind create cluster --name $(NAME) --wait $(WAIT) --config kind/kind-three-nodes.yaml

create6-%:
	kind create cluster --name $(NAME) --wait $(WAIT) --config kind/kind-six-nodes.yaml

delete-%:
	@kind delete cluster --name $(NAME)

env-%:
	@printf 'export KUBECONFIG=';kind get kubeconfig-path --name $(NAME)

clean:
	@kind get clusters | xargs -L1 -I% kind delete cluster --name %

listnodes-%:
	kind get nodes --name $(NAME)

list:
	@kind get clusters


.PHONY: tekton gatekeeper tekton% gatekeeper% create-% delete-% env-% clean list
