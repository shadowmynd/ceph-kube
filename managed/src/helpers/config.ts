import * as pulumi from "@pulumi/pulumi";

export default () => {
    const configString = pulumi.runtime.getConfig("fast:config");
    if(configString == null) {
        return {};
    }
    
    return JSON.parse(configString);
}