# Device zone mapping kata

## Context

A tech services network engineer has lost access to his inventory device map
which organised devices in a network zone tree structure. The dev team decided
to no longer support such kind of an app because of its unwieldy hierarchical
tree structure (JAVASCRIPT!) and turned the app off. It's out of service and
will no longer be maintained. The engineer got hold of a Database dump file
which contains every device hostname mapped against its specific zone.

## The task

Regenerate a device zone map that places devices into their zones by nesting
the zones up as nested hashes. Streaming the DB dump file in has been taken
care of.

### Input and output

This is the input to process:

```ruby
[{"<device hostname 1>": "<zone string>"}, {"<device hostname 1>": "<zone string>"}, …]
```

The output of the program will be passed into an output presenter that prints
the wanted zone map out in plain text. Your program does not need to perform
that step: returning the outputs below will suffice. 

That wanted output looks as follows:

```
<outer zone>: { <sub_zone>: { <lowest sub_zone>: [<hostnames>] } } }
```

#### Examples

No zone-allocation case:

```ruby
[{"host_1": ""}, {"host_2": ""}]

# => Exception "No zones found: devices are unallocated"
```

Basic common zone case:

```ruby
[{"host_1": "z_a, z_b, z_e"}, {"host_2": "z_a, z_b, z_e"}]

# => {z_a: {z_b: {z_e: {"devices": ["host_1", "host_2"] }}}}
```

Sub-zone separation case:

```ruby
[{"host_1": "z_a, z_b, z_e"}, {"host_2": "z_a, z_b"}]

# => {z_a: {z_b: [ {"devices": ["host_2"] }, {z_e: {"devices": ["host_1"] }} ] }}
```

More complex input case (a combination of the above):

```ruby
host1": "a,b,c"}, {"host2": "a,b,c,d"}, {"host3": "a,b,c,d"}, {"host4": "x,y"}]  

# => [{a: {b:  {c: [{"devices": ["host_1"]},{d: {"devices": ["host_2", "host_3"] }} ]} }}, {x: {y: {"devices": ["host_4"] }}}]
```
