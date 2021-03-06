# Small C++ CLI

It's based on Lua scripts and (for now) windows batch files.

## Prerequisites

Requires Lua interpreter to be available in console.
To install it just copy `gen.bat` and `cli` folder to your project root directory.

## Usage

### Class generator

```
gen class $1 $2 $3
```

- `$1` subproject folder (`YOUR_ROOT_PROJECT_DIR/subproject`)
- `$2` class name (see below for examples how to use it)
- `$3` optional modes (currently only supports "lib")

#### Examples

```
# no namespace
gen class subproject Clazz

# if contains '/' it will create namespace in generated files
gen class subproject namespace/Clazz

# it will auto create missing dirs (but only first one is a namespace)
gen class subproject namespace/a/b/Clazz

# Third argument is optional, if equal to "lib" it will include
# export header and mark class to be included in library (i.e. DLL)
gen class subproject namespace/Clazz lib
```

#### Generated files

```
gen class subproject Utils/Clazz lib
```

will produce

`subproject\src\Utils\Clazz.cpp`:

```c++
#include <Utils/Clazz.h>


namespace Utils
{

Clazz::Clazz()
{
}

Clazz::~Clazz()
{
}

}
```


`subproject\include\Utils\Clazz.h`:

```c++
#pragma once

#include <SubprojectExports.h>


namespace Utils
{

class SUBPROJECT_API Clazz
{
public:
    Clazz();
    Clazz(const Clazz&) = delete;
    Clazz& operator=(const Clazz&) = delete;
    virtual ~Clazz();

private:
};

}
```

and will print out some info

```
Add these manually to subproject/CMakeLists.txt

include/Utils/Clazz.h
src/Utils/Clazz.cpp
```

**Notes:**

- Templates can be adjusted to your needs, open `cli/templates/class.(cpp|h)` and do your thing.
- If `lib` mode is not specified headers are put in `src` folder rather than in `include`.
- Export header should be generated by your CMake build, something like this could work:
```cmake
include(GenerateExportHeader)
generate_export_header(Subproject
    BASE_NAME Subproject
    EXPORT_MACRO_NAME SUBPROJECT_API
    EXPORT_FILE_NAME SubprojectExports.h
    STATIC_DEFINE Subproject_BUILT_AS_STATIC
)
```
