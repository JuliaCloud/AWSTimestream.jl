module Timestream

using AWS: @service, JSONService
using AWS.UUIDs

@service Timestream_Query

export init_query_client, query

"""
    init_query_client()
This function will query for correct endpoint and then initialize client.
Please remember that this client has limited TTL. Usually 24h.
So if the query command fail, try to aquire new client.
"""
function init_query_client()
    ep_info = Timestream_Query.describe_endpoints()
    endpoints = first(ep_info)[2]
    a = endpoints[1]["Address"]
    uri = a[1:findfirst('.', a)] * "timestream"
    JSONService(
        "timestream", uri, "2018-11-01", "1.0", "Timestream_20181101"
    )
end


"""
    query(client, q)
Execute given query on Timestream and return all result records
This function will read all pages with data before returning the result.

# Arguments
- `client`: client created with `init_query_client` function
- `q`: Query string which specifies what should be returned (SQL command)
"""
function query(client, q)
    client_token = string(uuid4())
    result = client("Query", Dict{String,Any}("QueryString" => q, "ClientToken" => client_token))
    rows = result["Rows"]
    while haskey(result, "NextToken")
        result = client("Query", Dict{String,Any}("QueryString" => q, "ClientToken" => client_token, "NextToken" => result["NextToken"]))
        rows = [rows; result["Rows"]]
    end

    rows
end

end
