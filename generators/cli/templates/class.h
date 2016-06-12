#pragma once

$INCLUDE
$NAMESPACE_BEGIN
class $EXPORT_CLASS$CLASS_NAME
{
public:
	$CLASS_NAME();
	$CLASS_NAME(const $CLASS_NAME&) = delete;
	$CLASS_NAME& operator=(const $CLASS_NAME&) = delete;
	virtual ~$CLASS_NAME();

private:
};
$NAMESPACE_END
