SELECT      child.ID,
            child.calldate AS 'Call Date', 
            child.connect_duration / 86400 AS 'Call Duration', 
            child.caller AS 'Caller', 
            child.called AS 'Called', 
            child.whohanged AS 'Who hung up?',
            child.lastSIPresponseNum AS 'Status Code'
FROM       cdr AS child
WHERE      child.calldate>={ts '2015-03-01 00:00:00'} AND child.calldate<{ts '2015-03-23 23:59:59'}
ORDER BY    child.calldate