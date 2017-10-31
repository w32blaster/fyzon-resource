# fyzon-resource

The resource to get [Fyzon translations](https://github.com/w32blaster/fyzon) inside your [ConcourseCI](http://concourse.ci/) pipeline.

![Fyzon resource ConcourseCI Screenshot](https://raw.githubusercontent.com/w32blaster/fyzon-resource/master/img/screenshot1.jpg)

## Use the resource

The simplest example:

```yml
---

# declare custom resource type:
resource_types:
- name: fyzon-resource
  type: docker-image
  source:
    repository: w32blaster/fyzon-resource
    
# declare resource
resources:
- name: fyzon
  type: fyzon-resource
  source:
     url: "http://ci.my.fyzon.host"

# use it in your job
jobs:
- name: "Job Get Translations"
  plan:

    - get: fyzon
      params:
        project_id: 3
        format: properties
        delimeter: ":"
        countries:
          - gb: messages-en.properties
          - ru: messages-ru.properties

    # Build
    - task: "Task to deonstrate how to consume translation files"
      config:
        platform: linux
        image_resource:
          type: docker-image
          source: {repository: "alpine"}

        inputs:
        - name: fyzon

        run:
          path: sh
          args:
          - -exc
          - |
            
            ls fyzon        
            # ... here you will find two files: 
            # "messages-en.properties" and "messages-ru.properties"
            # copy them to the destination folder

```

Have fun.

# Development

We store logic in the `functions.js` file and we test it using [shunit2](https://github.com/kward/shunit2) library. To run tests, please do:

```
$ ./functions_test.sh
```

Example of payload expected from Concourse is stored in the file `payload.json`, it is used in Unit tests.
