# Client-Safe Shared Facts

This target-repository directory may contain only verified facts that are safe and legitimate to deliver with the client project contract.

Do not add active-work notes, contributor/routing logs, internal handoffs, lifecycle state, development state, runtime/model provenance, secrets, private data, or raw logs here.

Every file must be classifiable as `client_safe`. Allowed public ODN provenance is limited to selective native-comment `@batch odn-xxxx` source markers and exact `Batch: odn-xxxx` Git trailers; batch state itself remains in the Master Scaffold.
