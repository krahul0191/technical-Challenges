# First object to be evaluated
$object1 = @{
    "a" = @{
        "b" = @{
            "c" = "d"
        }
    }
}

# Second object to be evaluated
$object2 = @{
    "x" = @{
        "y" = @{
            "z" = "a"
        }
    }
}


# Function to get value from key
function GetValueFromKey($obj, $key) {
    $keys = $key -split "/"
    $result = $obj
    foreach ($k in $keys) {
        $result = $result[$k]
    }
    return $result
}

# Usage
$key1 = "a/b/c"
$value1 = GetValueFromKey $object1 $key1
Write-Host "Value for key '$key1' in object1: $value1"

$key2 = "x/y/z"
$value2 = GetValueFromKey $object2 $key2
Write-Host "Value for key '$key2' in object2: $value2"
